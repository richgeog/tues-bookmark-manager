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

  def sign_up(user)
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

end