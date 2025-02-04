defmodule NanoShdxw.RoomReservationTest do
  use NanoShdxw.DataCase

  alias NanoShdxw.RoomReservation

  describe "reservations" do
    alias NanoShdxw.RoomReservation.Reservation

    import NanoShdxw.RoomReservationFixtures

    @invalid_attrs %{starting_date: nil, ending_date: nil}

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert RoomReservation.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert RoomReservation.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data creates a reservation" do
      valid_attrs = %{starting_date: ~D[2025-01-23], ending_date: ~D[2025-01-23]}

      assert {:ok, %Reservation{} = reservation} = RoomReservation.create_reservation(valid_attrs)
      assert reservation.starting_date == ~D[2025-01-23]
      assert reservation.ending_date == ~D[2025-01-23]
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RoomReservation.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()
      update_attrs = %{starting_date: ~D[2025-01-24], ending_date: ~D[2025-01-24]}

      assert {:ok, %Reservation{} = reservation} =
               RoomReservation.update_reservation(reservation, update_attrs)

      assert reservation.starting_date == ~D[2025-01-24]
      assert reservation.ending_date == ~D[2025-01-24]
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               RoomReservation.update_reservation(reservation, @invalid_attrs)

      assert reservation == RoomReservation.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = RoomReservation.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> RoomReservation.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = RoomReservation.change_reservation(reservation)
    end
  end
end
