namespace :fbm do
  desc "Welcome"
  task :welcome do
    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: "Hello {{user_first_name}}, my name is Yvon.\nTime is too precious to wait in line!\nSave your time & order you lunch with me.\nSay 'Hello' anytime to find restaurants around you."
      },
    }, access_token: ENV['ACCESS_TOKEN'])
  end

  desc "Get started"
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
          title: 'Pay',
          payload: 'pay'
        },
        {
          type: 'postback',
          title: '➥ Menu',
          payload: 'menu'
        },
        {
          type: 'postback',
          title: 'Start a New Order',
          payload: 'start'
        },
        {
          type: 'web_url',
          title: 'Visit Website',
          url: 'http://www.hello-yvon.com'
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
  end
end
