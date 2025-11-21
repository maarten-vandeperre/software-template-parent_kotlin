package com.maarten.apis.maartenjakartaapis.resources

import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@Path("/hello")
class GreetingResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun hello() = "Hello from demo"
}

@Path("/bye")
class ByeResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun hello() = "Bye from demo"
}