package dev.brahmkshatriya.echo.download.db.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import dev.brahmkshatriya.echo.common.models.EchoMediaItem
import dev.brahmkshatriya.echo.utils.Serializer.toData

@Entity(tableName = "context_entity")
data class ContextEntity(
    @PrimaryKey(true)
    val id: Long,
    val itemId: String,
    val data: String,
) {
    val mediaItem by lazy { data.toData<EchoMediaItem>() }
}
