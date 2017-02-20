namespace :fbm do
  desc "Welcome"
  task :welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Salut {{user_first_name}}, je m'appelle Yvon.\nNe perds plus ton temps à faire la queue.\nCommande ton repas avec moi !\nDit 'Hello' à tout moment pour trouver des restaurants autour de toi."
      },
    }, access_token: ENV['ACCESS_TOKEN'])
  end

  desc "Hello"
  task :start do
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'new_thread',
      call_to_actions: [
        {
          payload: 'start'
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
  end

  desc "Persistant menu"
  task :persistant do
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
    }, access_token: ENV['ACCESS_TOKEN'])
  end
end
