package com.alizda.gsy_video_player

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.text.TextUtils
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.common.util.Util
import androidx.media3.database.DatabaseProvider
import androidx.media3.datasource.AssetDataSource
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DataSpec
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.datasource.RawResourceDataSource
import androidx.media3.datasource.RawResourceDataSource.RawResourceDataSourceException
import androidx.media3.datasource.cache.Cache
import androidx.media3.datasource.cache.CacheDataSource
import androidx.media3.datasource.cache.CacheKeyFactory
import androidx.media3.datasource.cache.ContentMetadata
import androidx.media3.datasource.cache.LeastRecentlyUsedCacheEvictor
import androidx.media3.datasource.cache.SimpleCache
import androidx.media3.exoplayer.dash.DashMediaSource
import androidx.media3.exoplayer.dash.DefaultDashChunkSource
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.rtsp.RtspMediaSource
import androidx.media3.exoplayer.smoothstreaming.DefaultSsChunkSource
import androidx.media3.exoplayer.smoothstreaming.SsMediaSource
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.exoplayer.upstream.DefaultBandwidthMeter
import androidx.media3.extractor.DefaultExtractorsFactory
import com.google.common.base.Ascii
import tv.danmaku.ijk.media.exo2.ExoMediaSourceInterceptListener
import java.io.File


@UnstableApi
class ExoSourceManager(context: Context, private val mMapHeadData: Map<String, String>?) {
    private val mAppContext: Context
    private var mDataSource: String? = null
    private var isCached = false

    init {
        mAppContext = context.applicationContext
    }

    /**
     * @param dataSource  链接
     * @param preview     是否带上header，默认有header自动设置为true
     * @param cacheEnable 是否需要缓存
     * @param isLooping   是否循环
     * @param cacheDir    自定义缓存目录
     */
    fun getMediaSource(dataSource: String, preview: Boolean, cacheEnable: Boolean, isLooping: Boolean, cacheDir: File, overrideExtension: String?): MediaSource {
        var mediaSource: MediaSource? = null
        if (exoMediaSourceInterceptListener != null) {
            mediaSource = exoMediaSourceInterceptListener!!.getMediaSource(dataSource, preview, cacheEnable, isLooping, cacheDir)
        }
        if (mediaSource != null) {
            return mediaSource
        }
        mDataSource = dataSource
        val contentUri = Uri.parse(dataSource)
        val mediaItem = MediaItem.fromUri(contentUri)
        val contentType = inferContentType(dataSource, overrideExtension)
        var uerAgent: String? = null
        if (mMapHeadData != null) {
            uerAgent = mMapHeadData["User-Agent"]
        }
        if ("android.resource" == contentUri.scheme) {
            val dataSpec = DataSpec(contentUri)
            val rawResourceDataSource = RawResourceDataSource(mAppContext)
            try {
                rawResourceDataSource.open(dataSpec)
            } catch (e: RawResourceDataSourceException) {
                e.printStackTrace()
            }
            val factory = DataSource.Factory { rawResourceDataSource }
            return ProgressiveMediaSource.Factory(
                    factory).createMediaSource(mediaItem)
        } else if ("assets" == contentUri.scheme) {
            val dataSpec = DataSpec(contentUri)
            val rawResourceDataSource = AssetDataSource(mAppContext)
            try {
                rawResourceDataSource.open(dataSpec)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            val factory = DataSource.Factory { rawResourceDataSource }
            return ProgressiveMediaSource.Factory(
                    factory).createMediaSource(mediaItem)
        }
        mediaSource = when (contentType) {
            C.CONTENT_TYPE_DASH -> DashMediaSource.Factory(DefaultDashChunkSource.Factory(getDataSourceFactoryCache(mAppContext, cacheEnable, preview, cacheDir, uerAgent)),
                    DefaultDataSource.Factory(mAppContext,
                            getHttpDataSourceFactory(mAppContext, preview, uerAgent))).createMediaSource(mediaItem)

            C.CONTENT_TYPE_OTHER -> ProgressiveMediaSource.Factory(getDataSourceFactoryCache(mAppContext, cacheEnable,
                    preview, cacheDir, uerAgent), DefaultExtractorsFactory())
                    .createMediaSource(mediaItem)
            C.CONTENT_TYPE_HLS -> HlsMediaSource.Factory(getDataSourceFactoryCache(mAppContext, cacheEnable,
                    preview, cacheDir, uerAgent)).createMediaSource(mediaItem)
            C.CONTENT_TYPE_SS -> SsMediaSource.Factory(
                    DefaultSsChunkSource.Factory(getDataSourceFactoryCache(mAppContext, cacheEnable,
                            preview, cacheDir, uerAgent)),
                    DefaultDataSource.Factory(mAppContext, getDataSourceFactoryCache(mAppContext, cacheEnable,
                            preview, cacheDir, uerAgent))
            )
                    .createMediaSource(mediaItem)
            C.CONTENT_TYPE_RTSP -> RtspMediaSource.Factory().createMediaSource(mediaItem)

            else -> ProgressiveMediaSource.Factory(getDataSourceFactoryCache(mAppContext, cacheEnable,
                    preview, cacheDir, uerAgent), DefaultExtractorsFactory())
                    .createMediaSource(mediaItem)
        }
        return mediaSource
    }

    fun release() {
        isCached = false
        if (mCache != null) {
            try {
                mCache!!.release()
                mCache = null
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun hadCached(): Boolean {
        return isCached
    }

    /**
     * 获取SourceFactory，是否带Cache
     */
    private fun getDataSourceFactoryCache(context: Context, cacheEnable: Boolean, preview: Boolean, cacheDir: File, uerAgent: String?): DataSource.Factory {
        if (cacheEnable) {
            val cache = getCacheSingleInstance(context, cacheDir)
            if (cache != null) {
                isCached = resolveCacheState(cache, mDataSource)
                val factory = CacheDataSource.Factory()
                return factory.setCache(cache)
                        .setCacheReadDataSourceFactory(getDataSourceFactory(context, preview, uerAgent))
                        .setFlags(CacheDataSource.FLAG_IGNORE_CACHE_ON_ERROR)
                        .setUpstreamDataSourceFactory(getHttpDataSourceFactory(context, preview, uerAgent))
            }
        }
        return getDataSourceFactory(context, preview, uerAgent)
    }

    /**
     * 获取SourceFactory
     */
    private fun getDataSourceFactory(context: Context, preview: Boolean, uerAgent: String?): DataSource.Factory {
        val factory = DefaultDataSource.Factory(context,
                getHttpDataSourceFactory(context, preview, uerAgent))
        if (preview) {
            factory.setTransferListener(DefaultBandwidthMeter.Builder(context).build())
        }
        return factory
    }

    private fun getHttpDataSourceFactory(context: Context, preview: Boolean, uerAgent: String?): DataSource.Factory {
        var uerAgentCopy = uerAgent
        if (uerAgentCopy == null) {
            uerAgentCopy = Util.getUserAgent(context, TAG)
        }
        var connectTimeout = DefaultHttpDataSource.DEFAULT_CONNECT_TIMEOUT_MILLIS
        var readTimeout = DefaultHttpDataSource.DEFAULT_READ_TIMEOUT_MILLIS
        if (httpConnectTimeout > 0) {
            connectTimeout = httpConnectTimeout
        }
        if (httpReadTimeout > 0) {
            readTimeout = httpReadTimeout
        }
        var allowCrossProtocolRedirects = false
        if (mMapHeadData != null && mMapHeadData.size > 0) {
            allowCrossProtocolRedirects = "true" == mMapHeadData["allowCrossProtocolRedirects"]
        }
        var dataSourceFactory: DataSource.Factory? = null
        if (exoMediaSourceInterceptListener != null) {
            dataSourceFactory = exoMediaSourceInterceptListener!!.getHttpDataSourceFactory(uerAgentCopy, if (preview) null else DefaultBandwidthMeter.Builder(mAppContext).build(),
                    connectTimeout,
                    readTimeout, mMapHeadData, allowCrossProtocolRedirects)
        }
        if (dataSourceFactory == null) {
            dataSourceFactory = DefaultHttpDataSource.Factory()
                    .setAllowCrossProtocolRedirects(allowCrossProtocolRedirects)
                    .setConnectTimeoutMs(connectTimeout)
                    .setReadTimeoutMs(readTimeout)
                    .setTransferListener(if (preview) null else DefaultBandwidthMeter.Builder(mAppContext).build())
            if (!mMapHeadData.isNullOrEmpty()) {
                dataSourceFactory.setDefaultRequestProperties(mMapHeadData)
            }
        }
        return dataSourceFactory
    }

    companion object {
        private const val TAG = "ExoSourceManager"
        private const val DEFAULT_MAX_SIZE = (512 * 1024 * 1024).toLong()
        const val TYPE_RTMP = 14
        private var mCache: Cache? = null
        /**
         * 忽律Https证书校验
         *
         */
        /**
         * 设置https忽略证书
         *
         * @param skipSSLChain true时是hulve
         */
        /**
         * 忽律Https证书校验
         *
         */
        @get:Deprecated("如果需要忽略证书，请直接使用 ExoMediaSourceInterceptListener 的 getHttpDataSourceFactory")
        @set:Deprecated("如果需要忽略证书，请直接使用 ExoMediaSourceInterceptListener 的 getHttpDataSourceFactory")
        @Deprecated("如果需要忽略证书，请直接使用 ExoMediaSourceInterceptListener 的 getHttpDataSourceFactory")
        var isSkipSSLChain = false

        /**
         * 如果设置小于 0 就使用默认 8000 MILLIS
         */
        var httpReadTimeout = -1

        /**
         * 如果设置小于 0 就使用默认 8000 MILLIS
         */
        var httpConnectTimeout = -1
        var isForceRtspTcp = true

        /**
         * 设置ExoPlayer 的 MediaSource 创建拦截
         */
        var exoMediaSourceInterceptListener: ExoMediaSourceInterceptListener? = null
        private var databaseProvider: DatabaseProvider? = null

        fun newInstance(context: Context, mapHeadData: Map<String, String>?): ExoSourceManager {
            return ExoSourceManager(context, mapHeadData)
        }

        fun resetExoMediaSourceInterceptListener() {
            exoMediaSourceInterceptListener = null
        }

        @SuppressLint("WrongConstant")
        fun inferContentType(fileName: String, overrideExtension: String?): @C.ContentType Int {
            var fileName = fileName
            fileName = Ascii.toLowerCase(fileName)
            return if (fileName.startsWith("rtmp:")) {
                TYPE_RTMP
            } else {
                inferContentType(Uri.parse(fileName), overrideExtension)
            }
        }

        fun inferContentType(uri: Uri?, overrideExtension: String?): @C.ContentType Int {
            return Util.inferContentType(uri!!, overrideExtension)
        }

        /**
         * 本地缓存目录
         */
        @Synchronized
        fun getCacheSingleInstance(context: Context, cacheDir: File?): Cache? {
            var dirs = context.cacheDir.absolutePath
            if (cacheDir != null) {
                dirs = cacheDir.absolutePath
            }
            if (mCache == null) {
                val path = dirs + File.separator + "exo"
                val isLocked = SimpleCache.isCacheFolderLocked(File(path))
                if (!isLocked) {
                    mCache = SimpleCache(File(path), LeastRecentlyUsedCacheEvictor(DEFAULT_MAX_SIZE), databaseProvider!!)
                }
            }
            return mCache
        }

        /**
         * Cache需要release之后才能clear
         */
        fun clearCache(context: Context, cacheDir: File?, url: String?) {
            try {
                val cache = getCacheSingleInstance(context, cacheDir)
                if (!TextUtils.isEmpty(url)) {
                    if (cache != null) {
                        removeCache(cache, url)
                    }
                } else {
                    if (cache != null) {
                        for (key in cache.keys) {
                            removeCache(cache, key)
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        fun removeCache(cache: Cache, url: String?) {
            val cachedSpans = cache.getCachedSpans(buildCacheKey(url))
            for (cachedSpan in cachedSpans) {
                try {
                    cache.removeSpan(cachedSpan!!)
                } catch (e: Exception) {
                    // Do nothing.
                }
            }
        }

        fun buildCacheKey(url: String?): String {
            val dataSpec = DataSpec(Uri.parse(url))
            return CacheKeyFactory.DEFAULT.buildCacheKey(dataSpec)
        }

        fun cachePreView(context: Context, cacheDir: File?, url: String?): Boolean {
            return resolveCacheState(getCacheSingleInstance(context, cacheDir), url)
        }

        /**
         * 根据缓存块判断是否缓存成功
         */
        private fun resolveCacheState(cache: Cache?, url: String?): Boolean {
            var isCache = true
            if (!TextUtils.isEmpty(url)) {
                val key = buildCacheKey(url)
                if (!TextUtils.isEmpty(key)) {
                    val cachedSpans = cache!!.getCachedSpans(key)
                    if (cachedSpans.size == 0) {
                        isCache = false
                    } else {
                        val contentLength = cache.getContentMetadata(key)[ContentMetadata.KEY_CONTENT_LENGTH, C.LENGTH_UNSET.toLong()]
                        var currentLength: Long = 0
                        for (cachedSpan in cachedSpans) {
                            currentLength += cache.getCachedLength(key, cachedSpan.position, cachedSpan.length)
                        }
                        isCache = currentLength >= contentLength
                    }
                } else {
                    isCache = false
                }
            }
            return isCache
        }
    }
}