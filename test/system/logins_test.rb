require "application_system_test_case"
require "colorize"

class LoginsTest < ApplicationSystemTestCase
  def setup
    @main = User.create(first_name: "Isaac", last_name: "Asimov", email: "isaac.asimov@thp.org", password: "terminus", password_confirmation: "terminus")
    @second = User.create(first_name: "Isaac", last_name: "Newton", email: "isaac.newton@thp.org", password: "gravity", password_confirmation: "gravity")
    @user = {"first_name" => "Hari", "last_name" => "Seldon", "email" => "hari.seldon@thp.org", "password" => "foundation", "password_confirmation" => "foundation"}
    @temp = User.new(first_name: "Cave", last_name: "Johnson", email: "cave.johnson@thp.org", password: "caroline", password_confirmation: "caroline")
  end
  
  def login
    visit login_path
    fill_in 'session_email', with: 'isaac.asimov@thp.org'
    fill_in 'session_password', with: 'terminus'
    find('input[type="submit"]').click
  end
  
  test 'Invalid w/o first name' do
    @temp.first_name = ""
    print "\n[Signin] User must have first name -> ".colorize(:red)
    assert_not @temp.valid?, 'user is valid without a name'
  end
  
  test 'Invalid w/ blank last name' do
    @temp.last_name = " "
    print "\n[Signin] User cannot have a blank last name -> ".colorize(:red)
    assert_not @temp.valid?, 'user is valid with a blank last name'
  end
  
  test 'Invalid w/ same email as another user' do
    print "\n[Signin] User cannot have same email -> ".colorize(:red)
    assert_not_nil @temp.dup.valid?
  end
  
  test "Login present when not logged in" do
    visit root_path
    print "\n[Navbar] Login present when not logged in -> ".colorize(:red)
    assert_selector('body > nav > ul > li:nth-child(2) > a', text: 'Login')
  end
  
  test "Sign up present when not logged in" do
    visit root_path
    print "\n[Navbar] Sign up present when not logged in -> ".colorize(:red)
    assert_selector('body > nav > ul > li:nth-child(1) > a', text: 'Sign up')
  end
  
  test "Logout present when login" do
    login
    visit root_path
    print "\n[Navbar] Logout present when login -> ".colorize(:red)
    assert_selector('body > nav > ul > a', text: 'Logout')
  end
  
  test "Cannot access club when logout" do
    visit club_path
    print "\n[Access] Cannot access club when logout -> ".colorize(:red)
    assert_current_path '/login'
  end
  
  test "Cannot signup with incomplete informations" do
    visit signup_path
    fill_in 'user_first_name', with: @user["first_name"]
    #fill_in 'user_last_name', with: @user["last_name"]
    fill_in 'user_email', with: @user["email"]
    fill_in 'user_password', with: @user["password"]
    fill_in 'user_password_confirmation', with: @user["password_confirmation"]
    find('input[type="submit"]').click
    print "\n[Signin] Cannot signup with incomplete informations -> ".colorize(:red)
    assert_current_path '/signup'
  end
  
  test "Show link is present when logged in" do
    login
    print "\n[Navbar] Show link is present when logged in -> ".colorize(:red)
    assert_selector('#navbarNavAltMarkup > div > a:nth-child(3)', text: 'Show') 
  end
  
  test "Show display user infos" do
    login
    visit user_path(@main.id)
    print "\n[Infos] Show display user infos -> ".colorize(:red)
    assert_selector('body > div > p:nth-child(4)', text: @main.email) 
  end
  
  test "Cannot access other edit" do
    login
    visit edit_user_path(@second.id)
    print "\n[Access] Cannot access other edit page -> ".colorize(:red)
    assert_current_path '/club'
  end
  
  test "Edit is prepopulated with attributes" do
    login
    visit edit_user_path(@main.id)
    print "\n[Form] Edit is prepopulated with attributes -> ".colorize(:red)
    assert find("input[placeholder='#{@main.email}']")
  end
  
  test "Cannot access edit when not logged" do
    visit edit_user_path(@main.id)
    print "\n[Access] Cannot access edit when not logged -> ".colorize(:red)
    assert_current_path '/login'
  end
  
  test "Diplay profile link in club page" do
    login
    visit club_path
    print "\n[Info] Diplay profile link in club page -> ".colorize(:red)
    assert find("td > a[href='/users/#{@main.id}']")
  end
end
