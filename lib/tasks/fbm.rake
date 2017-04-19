namespace :fbm do
  desc "Yvon Greeting Text"
  task yvon_greeting: :environment do
    success =  Facebook::Messenger::Profile.set({
      greeting:[
        {
          locale: "default",
          text: "Hello it's Yvon"
        },
        {
          locale: "fr_FR",
          text: "Salut {{user_first_name}}, je m'appelle Yvon"
        }
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])

    if success
      puts 'Yvon Greeting Text set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=greeting&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end

  desc "Yvon Get Started Button"
  task yvon_start: :environment do
    success =  Facebook::Messenger::Profile.set({
      get_started: {
        payload: "start"
      }
    }, access_token: ENV['YVON_ACCESS_TOKEN'])

    if success
      puts 'Yvon Get Started Button set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=get_started&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end

  desc "Yvon Persistent Menu"
  task yvon_menu: :environment do
    success =  Facebook::Messenger::Profile.set({
      persistent_menu:[
        {
          locale: "default",
          composer_input_disabled: false,
          call_to_actions: [
            {
              type: "postback",
              title: "🍴 Nouvelle recherche",
              payload: "start"
            },
            {
              type: "postback",
              title: "💳 Mettre à jour ma carte",
              payload: "menu_update_card"
            },
            {
              type: "nested",
              title: "🎁 Partage",
              call_to_actions: [
                {
                  type: "postback",
                  title: "Partage Yvon avec tes amis",
                  payload: "share"
                },
                {
                  type: "web_url",
                  title: "Suis moi sur Facebook",
                  url: "https://www.facebook.com/HelloYvon/"
                },
                {
                  type: "web_url",
                  title: "www.hello-yvon.com",
                  url: "http://www.hello-yvon.com/"
                }
              ]
            }
          ]
        },
        {
          locale: "fr_FR",
          composer_input_disabled: false,
          call_to_actions: [
            {
              type: "postback",
              title: "🍴 Nouvelle recherche",
              payload: "start"
            },
            {
              type: "postback",
              title: "💳 Mettre à jour ma carte",
              payload: "menu_update_card"
            },
            {
              type: "nested",
              title: "🎁 Partage",
              call_to_actions: [
                {
                  type: "postback",
                  title: "Partage Yvon avec tes amis",
                  payload: "share"
                },
                {
                  type: "web_url",
                  title: "Suis moi sur Facebook",
                  url: "https://www.facebook.com/HelloYvon/"
                },
                {
                  type: "web_url",
                  title: "www.hello-yvon.com",
                  url: "http://www.hello-yvon.com/"
                }
              ]
            }
          ]
        },
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])

    if success
      puts 'Yvon Persistent Menu set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=persistent_menu&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end

  desc "Aline Greeting Text"
  task aline_greeting: :environment do
    success =  Facebook::Messenger::Profile.set({
      greeting:[
        {
          locale: "default",
          text: "Hello it's Aline"
        },
        {
          locale: "fr_FR",
          text: "Salut {{user_first_name}}, je m'appelle Aline"
        }
      ]
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])

    if success
      puts 'Aline Greeting Text set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=greeting&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end

  desc "Aline Get Started Button"
  task aline_start: :environment do
    success =  Facebook::Messenger::Profile.set({
      get_started: {
        payload: "start"
      }
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])

    if success
      puts 'Aline Get Started Button set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=get_started&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end

  desc "Aline Persistent Menu"
  task aline_menu: :environment do
    success =  Facebook::Messenger::Profile.set({
      persistent_menu:[
        {
          locale: "default",
          composer_input_disabled: true,
          call_to_actions: [
            {
              type: "nested",
              title: "Mon service",
              call_to_actions: [
                {
                  type: "postback",
                  title: "Commandes en cours",
                  payload: "orders"
                },
                {
                  type: "postback",
                  title: "Temps de préparation",
                  payload: "preparation_time"
                },
                {
                  type: "postback",
                  title: "Service ouvert / fermé",
                  payload: "duty"
                },
                {
                  type: "postback",
                  title: "Mettre à jour les plats",
                  payload: "meals"
                }
              ]
            },
            {
              type: "postback",
              title: "Connexion",
              payload: "start"
            }
          ]
        },
        {
          locale: "fr_FR",
          composer_input_disabled: true,
          call_to_actions: [
            {
              type: "nested",
              title: "Mon service",
              call_to_actions: [
                {
                  type: "postback",
                  title: "Commandes en cours",
                  payload: "orders"
                },
                {
                  type: "postback",
                  title: "Temps de préparation",
                  payload: "preparation_time"
                },
                {
                  type: "postback",
                  title: "Service ouvert / fermé",
                  payload: "duty"
                },
                {
                  type: "postback",
                  title: "Mettre à jour les plats",
                  payload: "meals"
                }
              ]
            },
            {
              type: "postback",
              title: "Connexion",
              payload: "start"
            }
          ]
        }
      ]
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])

    if success
      puts 'Aline Persistent Menu set :'
      puts RestClient.get("https://graph.facebook.com/v2.8/me/messenger_profile?fields=persistent_menu&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end
end
