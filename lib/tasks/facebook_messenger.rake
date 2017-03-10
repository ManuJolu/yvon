namespace :fbm do
  desc "Yvon Welcome"
  task :yvon_welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Salut {{user_first_name}}, je m'appelle Yvon.\nNe perds plus ton temps à faire la queue.\nCommande ton repas avec moi !\nDis 'Hello' à tout moment pour trouver des restaurants autour de toi."
      },
    }, access_token: ENV['YVON_ACCESS_TOKEN'])
    puts "Yvon welcome message set."
  end

  desc "Yvon Start"
  task :yvon_start do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'new_thread',
      call_to_actions: [
        {
          payload: 'start'
        }
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])
    puts "Yvon start call to action set."
  end

  desc "Yvon Persistent menu"
  task :yvon_persistent do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'existing_thread',
      call_to_actions: [
        {
          type: 'postback',
          title: '🍴 Nouvelle commande',
          payload: 'start'
        },
        {
          type: 'postback',
          title: '🎁 Partage Yvon avec tes amis',
          payload: 'share'
        },
        {
          type: 'web_url',
          title: '🌍 www.hello-yvon.com',
          url: 'http://www.hello-yvon.com'
        }
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])
    puts "Yvon persistent menu set."
  end

  desc "Aline Welcome"
  task :aline_welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Salut {{user_first_name}}, je m'appelle Aline.\nConnecte toi à ton restaurant et je t'envoie les commandes passées par tes clients avec Yvon - @HelloYvon.\nN'oublies pas le menu du bas pour modifier les paramètres de ton restaurant, et bon service !"
      },
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])
    puts "Aline welcome message set."
  end

  desc "Aline Start"
  task :aline_start do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'new_thread',
      call_to_actions: [
        {
          payload: 'start'
        }
      ]
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])
    puts "Aline start call to action set."
  end

  desc "Aline Persistent menu"
  task :aline_persistent do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'existing_thread',
      call_to_actions: [
        {
          type: 'postback',
          title: 'Commandes en cours',
          payload: 'orders'
        },
        {
          type: 'postback',
          title: 'Temps de préparation',
          payload: 'preparation_time'
        },
        {
          type: 'postback',
          title: 'Service ouvert / fermé',
          payload: 'duty'
        },
        {
          type: 'postback',
          title: 'Connexion / déconnexion',
          payload: 'start'
        }
      ]
    }, access_token: ENV['ALINE_ACCESS_TOKEN'])
    puts "Aline persistent menu set."
  end
end
