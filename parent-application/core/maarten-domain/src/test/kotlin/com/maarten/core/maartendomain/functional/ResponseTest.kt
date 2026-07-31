package com.maarten.core.maartendomain.functional

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class ResponseTest {

    @Test
    fun `success response maps its data`() {
        val response = Response.success(2).map { it * 21 }

        assertTrue(response is SuccessResponse)
        assertEquals(42, (response as SuccessResponse).data)
    }

    @Test
    fun `error response keeps its error messages when mapped`() {
        val response = Response.fail<Int>(listOf("boom")).map { it * 21 }

        assertTrue(response is ErrorResponse)
        assertEquals(listOf("boom"), (response as ErrorResponse).errorMessages)
    }
}
