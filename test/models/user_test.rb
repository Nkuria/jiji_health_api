require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      full_name: "Test User",
      phone_number: "+254712345678",
      email: "test@example.com",
      password: "password123"
    )
  end

  test "valid user" do
    assert @user.valid?
  end

  test "requires full name" do
    @user.full_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:full_name], "can't be blank"
  end

  test "requires phone number" do
    @user.phone_number = nil
    assert_not @user.valid?
    assert_includes @user.errors[:phone_number], "can't be blank"
  end

  test "requires password" do
    @user.password = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "requires unique phone number" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:phone_number], "has already been taken"
  end

  test "requires email" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "requires unique email" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "email format validation" do
    valid_emails = %w[user@example.com USER@example.COM first.last@example.co.uk first+last@example.com]
    invalid_emails = %w[user@example,com user_at_example.com user@example.]

    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email} should be valid"
    end

    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid"
      assert_includes @user.errors[:email], "must be a valid email address"
    end
  end

  test "authenticates with correct password" do
    @user.save
    assert @user.authenticate("password123")
  end

  test "does not authenticate with incorrect password" do
    @user.save
    assert_not @user.authenticate("wrongpassword")
  end
end