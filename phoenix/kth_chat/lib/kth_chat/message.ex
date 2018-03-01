defmodule KthChat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias KthChat.Message


  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end

  def get_messages(limit \\ 20) do
    KthChat.Repo.all(Message, limit: limit)
  end


end
