package com.maarten.core.maartencoreutils.logging

interface Logger {
    fun debug(message: String, vararg arguments: String)
    fun info(message: String, vararg arguments: String)
    fun warn(message: String, vararg arguments: String)
    fun error(message: String, vararg arguments: String)
}