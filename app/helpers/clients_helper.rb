module ClientsHelper
  def whatsapp_album_link(client, album)
    # Rails auto-detects host, port, https/http
    album_url = album_access_url(id: album)

    message = "Salut #{client.name}: voici le lien pour acceder à votre album #{album_url} . merci pour la confiance que vous nous accordez"
    encoded_message = ERB::Util.url_encode(message)

    "https://wa.me/#{client.tel}?text=#{encoded_message}"
  end
end
