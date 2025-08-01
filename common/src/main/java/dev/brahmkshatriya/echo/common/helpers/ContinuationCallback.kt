package dev.brahmkshatriya.echo.common.helpers

import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.CompletionHandler
import kotlinx.coroutines.suspendCancellableCoroutine
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import java.io.IOException
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class ContinuationCallback(
    private val call: Call,
    private val continuation: CancellableContinuation<Response>
) : Callback, CompletionHandler {

    override fun onResponse(call: Call, response: Response) {
        continuation.resume(response)
    }

    override fun onFailure(call: Call, e: IOException) {
        if (!call.isCanceled()) {
            continuation.resumeWithException(e)
        }
    }

    override fun invoke(cause: Throwable?) {
        try {
            call.cancel()
        } catch (_: Throwable) {}
    }

    companion object {
        /**
         * Suspends the current coroutine,
         * performs the network call and resumes the coroutine with the response
         */
        suspend inline fun Call.await(): Response {
            return suspendCancellableCoroutine { continuation ->
                val callback = ContinuationCallback(this, continuation)
                enqueue(callback)
                continuation.invokeOnCancellation(callback)
            }
        }
    }
}
