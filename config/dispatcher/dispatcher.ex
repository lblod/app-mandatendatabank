defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    any: [ "*/*" ]
  ]

  define_layers [ :static, :web_page, :api_services, :not_found ]

  @static %{ layer: :static }
  @api %{ layer: :api_services }

  # Option calls are accepted by default
  options "/*_path", _ do
    conn
    |> Plug.Conn.put_resp_header( "access-control-allow-headers", "content-type,accept" )
    |> Plug.Conn.put_resp_header( "access-control-allow-methods", "*" )
    |> send_resp( 200, "{ \"message\": \"ok\" }" )
  end

  get "/assets/*path", @static do
    forward conn, path, "http://mandaten/assets/"
  end

  match "/files/*path", @static do
    forward conn, path, "http://filehost/"
  end

  get "/favicon.ico", @static do
    send_resp( conn, 404, "" )
  end

  get "/sitemap.xml", @static do
    forward conn, [], "http://sitemap/sitemap.xml"
  end

  get "/*path", %{ layer: :web_page, accept: %{ html: true } } do
    forward conn, path, "http://mandaten/"
  end

  match "/bestuurseenheden/*path", @api do
    forward conn, path, "http://cache/bestuurseenheden/"
  end
  match "/werkingsgebieden/*path", @api do
    forward conn, path, "http://cache/werkingsgebieden/"
  end
  match "/bestuurseenheid-classificatie-codes/*path", @api do
    forward conn, path, "http://cache/bestuurseenheid-classificatie-codes/"
  end
  match "/bestuursorganen/*path", @api do
    forward conn, path, "http://cache/bestuursorganen/"
  end
  match "/bestuursorgaan-classificatie-codes/*path", @api do
    forward conn, path, "http://cache/bestuursorgaan-classificatie-codes/"
  end
  match "/fracties/*path", @api do
    forward conn, path, "http://cache/fracties/"
  end
  match "/fractietypes/*path", @api do
    forward conn, path, "http://cache/fractietypes/"
  end
  match "/geboortes/*path", @api do
    forward conn, path, "http://cache/geboortes/"
  end
  match "/lijsttypes/*path", @api do
    forward conn, path, "http://cache/lijsttypes/"
  end
  match "/kandidatenlijsten/*path", @api do
    forward conn, path, "http://cache/kandidatenlijsten/"
  end
  match "/lidmaatschappen/*path", @api do
    forward conn, path, "http://cache/lidmaatschappen/"
  end
  match "/mandaten/*path", @api do
    forward conn, path, "http://cache/mandaten/"
  end
  match "/bestuursfunctie-codes/*path", @api do
    forward conn, path, "http://cache/bestuursfunctie-codes/"
  end
  match "/mandatarissen/*path", @api do
    forward conn, path, "http://cache/mandatarissen/"
  end
  match "/mandataris-status-codes/*path", @api do
    forward conn, path, "http://cache/mandataris-status-codes/"
  end
  match "/beleidsdomein-codes/*path", @api do
    forward conn, path, "http://cache/beleidsdomein-codes/"
  end
  match "/personen/*path", @api do
    forward conn, path, "http://cache/personen/"
  end
  match "/geslacht-codes/*path", @api do
    forward conn, path, "http://cache/geslacht-codes/"
  end
  match "/identificatoren/*path", @api do
    forward conn, path, "http://cache/identificatoren/"
  end
  match "/rechtsgronden-aanstelling/*path", @api do
    forward conn, path, "http://cache/rechtsgronden-aanstelling/"
  end
  match "/rechtsgronden-beeindiging/*path", @api do
    forward conn, path, "http://cache/rechtsgronden-beeindiging/"
  end
  match "/rechtstreekse-verkiezingen/*path", @api do
    forward conn, path, "http://cache/rechtstreekse-verkiezingen/"
  end
  match "/rechtsgronden/*path", @api do
    forward conn, path, "http://cache/rechtsgronden/"
  end
  match "/tijdsgebonden-entiteiten/*path", @api do
    forward conn, path, "http://cache/tijdsgebonden-entiteiten/"
  end
  match "/tijdsintervallen/*path", @api do
    forward conn, path, "http://cache/tijdsintervallen/"
  end
  match "/verkiezingsresultaten/*path", @api do
    forward conn, path, "http://cache/verkiezingsresultaten/"
  end
  match "/verkiezingsresultaat-gevolg-codes/*path", @api do
    forward conn, path, "http://cache/verkiezingsresultaat-gevolg-codes/"
  end
  get "/exports/*path", @api do
    # we bypass the cache on purpose since mu-cl-resources is not the master of the exports
    forward conn, path, "http://resource/exports/"
  end

  ###############################################################
  # delta-files
  ###############################################################
  get "/delta-files/:id/download", %{ layer: :api_services, accept: %{ any: true } } do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end
  get "/sync/mandatarissen/files/*path", %{ layer: :api_services, accept: %{ any: true } } do
    forward conn, path, "http://mandatarissen-producer/files/"
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
