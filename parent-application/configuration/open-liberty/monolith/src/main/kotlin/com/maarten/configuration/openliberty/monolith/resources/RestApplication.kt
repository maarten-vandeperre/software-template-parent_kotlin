package com.maarten.configuration.openliberty.monolith.resources

import jakarta.ws.rs.ApplicationPath
import jakarta.ws.rs.core.Application


@ApplicationPath("api")
class RestApplication : Application()