feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = User.new(email: 'alice@example.com',
                    password: '12345678',
                    password_confirmation: '12345678')
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    user = User.new(password_confirmation: 'wrong',
                    email: 'alice@example.com',
                    password: '12345678')
    expect { sign_up(user) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = User.new(email: 'alic@example.com',
                    password: '12345678',
                    password_confirmation: '1')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'without a email address entered' do
    user = User.new(email: '',
                    password: '12345678',
                    password_confirmation: '12345678')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with an existing email' do
    user = User.new(email: 'alice@example.com',
                    password: '12345678',
                    password_confirmation: '12345678')
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do

 let(:user) do
   User.create(email: 'alice@example.com',
               password: '12345678',
               password_confirmation: '12345678')
 end

   scenario 'with correct credentials' do
     sign_in(user)
     expect(page).to have_content "Welcome, #{user.email}"
   end
end

feature 'User signs out' do

 let(:user) do
  before(:each) do
    user = User.create(email: 'alice@example.com',
                       password: '12345678',
                       password_confirmation: '12345678')
  end

  scenario 'while being signed in' do
    sign_in(user)#(email: 'alice@example.com', password: '12345678')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!') # where does this message go?
    expect(page).not_to have_content('Welcome, alice@example.com')
  end
 end

 feature 'Password reset' do

   scenario 'requesting a password reset' do
     user = User.create(email: 'test@test.com', password: 'secret1234',
                        password_confirmation: 'secret1234')
     visit '/password_reset'
     fill_in 'email', with: user.email
     click_button 'Reset password'
     user = User.first(email: user.email)
     expect(user.password_token).not_to be_nil
     expect(page).to have_content 'Check your emails'
   end
  end
end