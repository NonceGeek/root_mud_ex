import Config

config(:logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:pid, :request_id]
)

config(:web3_mud_ex_example, :accounts_path, "data/accounts")

if Mix.env() == :test do
  config(:web3_mud_ex_example, :accounts_path, "test/data/accounts")

  config(:web3_mud_ex_example, :listener, start: false)
  config(:web3_mud_ex_example, :telemetry, start: false)
  config(:web3_mud_ex_example, :world, kickoff: false)

  config(:logger, level: :warn)

  config(:bcrypt_elixir, log_rounds: 2)
end
