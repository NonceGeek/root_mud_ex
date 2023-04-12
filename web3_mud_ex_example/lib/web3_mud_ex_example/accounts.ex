defmodule Web3MudExExample.Accounts.Account do
  @moduledoc """
    Struct for a user account
  """

  @derive Jason.Encoder
  defstruct [:username, :password_hash]

  def load(account_data) do
    %__MODULE__{
      username: account_data["username"],
      password_hash: account_data["password_hash"],
      # sui_addr: account_data["sui_addr"],
      # priv: account_data["priv"],
    }
  end
end

defmodule Web3MudExExample.Accounts.AccountError do
  defexception [:reason, :message]
end

defmodule Web3MudExExample.Accounts do
  @moduledoc """
  Account system

  Let players register an account and then sign in later.
  """

  alias Web3MudExExample.Accounts.Account
  alias Web3MudExExample.Accounts.AccountError

  @accounts_path Application.compile_env(:web3_mud_ex_example, :accounts_path)

  @doc """
  Register a new account

  Creates a new player file in `#{@accounts_path}`
  """
  def register(username, password) do
    path = Path.join(@accounts_path, "#{username}.json")

    case File.exists?(path) do
      true ->
        {:error, %AccountError{reason: :exists, message: "Account already exists"}}

      false ->

        account = %Account{
          username: username,
          password_hash: Bcrypt.hash_pwd_salt(password),
        }

        :ok = File.write(path, Jason.encode!(account))

        {:ok, account}
    end
  end

  @doc """
  Check if an account exists already
  """
  def exists?(username) do
    path = Path.join(@accounts_path, "#{username}.json")

    File.exists?(path)
  end

  @doc """
  Validate a player's login against known accounts
  """
  def validate_login(username, password) do
    path = Path.join(@accounts_path, "#{username}.json")

    case File.exists?(path) do
      true ->
        file = File.read!(path)
        account_data = Jason.decode!(file)

        account = Account.load(account_data)

        case Bcrypt.verify_pass(password, account.password_hash) do
          true ->
            {:ok, account}

          false ->
            {:error, %AccountError{reason: :invalid, message: "Invalid password"}}
        end

      false ->
        Bcrypt.no_user_verify()

        {:error, %AccountError{reason: :invalid, message: "Invalid password"}}
    end
  end

  @doc """
  Delete an account

  If the account does not exist, then `:ok` is still returned
  """
  def delete(username) do
    path = Path.join(@accounts_path, "#{username}.json")

    case File.exists?(path) do
      true ->
        File.rm!(path)

      false ->
        :ok
    end
  end
end
