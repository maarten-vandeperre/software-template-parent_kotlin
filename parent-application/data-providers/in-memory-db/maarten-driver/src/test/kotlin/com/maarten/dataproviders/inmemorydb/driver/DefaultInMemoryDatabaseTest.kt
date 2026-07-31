package com.maarten.dataproviders.inmemorydb.driver

import com.maarten.core.maartendomain.functional.SuccessResponse
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class DefaultInMemoryDatabaseTest {

    @Test
    fun `persist and findAll round-trip`() {
        val db = DefaultInMemoryDatabase<String>()

        val persistResponse = db.persist("ref-1", "hello")
        assertTrue(persistResponse is SuccessResponse)

        val findAllResponse = db.findAll()
        assertTrue(findAllResponse is SuccessResponse)
        assertEquals(listOf("hello"), (findAllResponse as SuccessResponse).data)
    }

    @Test
    fun `persisting the same ref twice overwrites the value`() {
        val db = DefaultInMemoryDatabase<String>()
        db.persist("ref-1", "first")
        db.persist("ref-1", "second")

        val findAllResponse = db.findAll() as SuccessResponse
        assertEquals(listOf("second"), findAllResponse.data)
    }
}
