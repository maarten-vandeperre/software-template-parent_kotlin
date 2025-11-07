package com.maarten.apis.maartenjakartaapis.resources

import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@Path("/goodbye")
class GoodbyeResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun goodbye() = "Goodbye from RESTEasy Reactive"
}