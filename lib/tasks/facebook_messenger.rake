namespace :fbm do
  desc "Yvon Welcome"
  task :yvon_welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Salut {{user_first_name}}, je m'appelle Yvon.\nNe perds plus ton temps à faire la queue.\nCommande ton repas avec moi !\nDit 'Hello' à tout moment pour trouver des restaurants autour de toi."
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

  desc "Yvon Persistant menu"
  task :yvon_persistant do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'existing_thread',
      call_to_actions: [
        {
          type: 'postback',
          title: '➥ Liste des restaurants',
          payload: 'map'
        },
        {
          type: 'postback',
          title: 'Nouvelle commande',
          payload: 'start'
        },
        {
          type: 'web_url',
          title: 'hello-yvon.com',
          url: 'http://www.hello-yvon.com'
        }
      ]
    }, access_token: ENV['YVON_ACCESS_TOKEN'])
    puts "Yvon persistant menu set."
  end

  desc "Aline Welcome"
  task :aline_welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Salut {{user_first_name}}, je m'appelle Aline.\nConnecte toi à ton restaurant et je t'envoie les commandes passées par tes clients avec Yvon - @HelloYvon.\nN'oublies pas le menu en bas à gauche pour modifier les paramètres de ton restaurant, et bon service !"
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

  desc "Aline Persistant menu"
  task :aline_persistant do
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
    puts "Aline persistant menu set."
  end
end
