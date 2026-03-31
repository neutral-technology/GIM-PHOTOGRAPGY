module ClientsHelper
  def whatsapp_album_link(client, album, user)
    # Rails auto-detects host, port, https/http
    # album_url = album_access_url(id: album)
    album_url = album_access_url(album)

    message = "Salut #{client.name} 👋\n\n" \
            "Voici le lien pour accéder à votre album 📸 :\n" \
            "#{album_url}\n\n" \
            "🔐 Mot de passe : #{album.access_code}\n\n" \
            "📍 Studio : #{user.full_name}\n" \
            "Adresse : #{user.city}\n\n" \
            "Merci pour la confiance 🙏"

    encoded_message = ERB::Util.url_encode(message)

    "https://wa.me/#{client.tel}?text=#{encoded_message}"
  end

  def whatsapp_vip_link(client, user)
    message = "🎉 Félicitations #{client.name} !\n\n" \
              "Vous êtes désormais CLIENT VIP ⭐\n\n" \
              "Merci pour votre fidélité 💝\n" \
              "Un cadeau vous est reservé 🥳, Passez à notre studio pour plus de details !\n\n" \
              "📍 Studio : #{user.full_name}\n" \
              "Adresse : #{user.city}"

    encoded_message = ERB::Util.url_encode(message)

    "https://wa.me/#{clean_phone(client.tel)}?text=#{encoded_message}"
  end

  def clean_phone(phone)
    phone.to_s.gsub(/\D/, '')
  end
end
