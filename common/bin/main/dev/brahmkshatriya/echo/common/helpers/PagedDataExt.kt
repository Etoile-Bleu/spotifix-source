package dev.brahmkshatriya.echo.common.helpers

suspend fun <T : Any> PagedData<T>.loadFirst(): List<T> = when (this) {
    is PagedData.Single -> this.loadAll()
    is PagedData.Continuous -> this.loadList(null).data
    is PagedData.Concat -> this.loadAll()
    is PagedData.Suspend -> this.loadAll()
}
