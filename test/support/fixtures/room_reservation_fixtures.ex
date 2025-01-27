defmodule NanoShdxw.RoomReservationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NanoShdxw.RoomReservation` context.
  """

  @doc """
  Generate a reservation.
  """
  def reservation_fixture(attrs \\ %{}) do
    {:ok, reservation} =
      attrs
      |> Enum.into(%{
        ending_date: ~D[2025-01-23],
        starting_date: ~D[2025-01-23]
      })
      |> NanoShdxw.RoomReservation.create_reservation()

    reservation
  end
end
