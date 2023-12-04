use actix_web::*;
use std::env;

// hellow world
async fn hello_world(_req: HttpRequest) -> Result<HttpResponse> {
    return Ok(HttpResponse::Ok().body("Hello world!"));
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();
    let port = &args[1];
    let port: u16 = port.parse().unwrap();

    println!("Starting server on port {}", port);

    return HttpServer::new(||
        App::new()
        .route("/", web::get().to(hello_world))
    )
    .bind(("127.0.0.1", port))?
    .run()
    .await;
}