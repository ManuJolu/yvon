namespace :fbm do
  desc "Yvon Greeting Text"
  task yvon_greeting: :environment do
    success =  Facebook::Messenger::Profile.set({
      greeting:[
        {
          locale: "default",
          text: "Hello {{user_first_name}}, shall we start?"
        },
        {
          locale: "fr_FR",
          text: "Hello {{user_first_name}}, on y va ?"
        }
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])

    if success
      puts 'Yvon Greeting Text set :'
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=greeting&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
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
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=get_started&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
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
              title: "👋 Hello Yvon",
              payload: "hello"
            },
            {
              type: "postback",
              title: "💳 Update my credit card",
              payload: "menu_update_card"
            },
            {
              type: "postback",
              title: "🎁 Share",
              payload: "share"
            }
          ]
        },
        {
          locale: "fr_FR",
          composer_input_disabled: false,
          call_to_actions: [
            {
              type: "postback",
              title: "👋 Hello Yvon",
              payload: "hello"
            },
            {
              type: "postback",
              title: "💳 Mets à jour ma carte",
              payload: "menu_update_card"
            },
            {
              type: "postback",
              title: "🎁 Partage",
              payload: "share"
            }
          ]
        },
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])

    if success
      puts 'Yvon Persistent Menu set :'
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=persistent_menu&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
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
          text: "Hello {{user_first_name}}, shall we start?"
        },
        {
          locale: "fr_FR",
          text: "Salut {{user_first_name}}, on y va ?"
        }
      ]
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])

    if success
      puts 'Aline Greeting Text set :'
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=greeting&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
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
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=get_started&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
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
      puts RestClient.get("https://graph.facebook.com/v2.9/me/messenger_profile?fields=persistent_menu&access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
    else
      puts 'Failure'
    end
  end
end
