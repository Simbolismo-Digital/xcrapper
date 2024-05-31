defmodule Xcrapper.Scrapper.Scheduler do
  @moduledoc """
  GenServer to schedule scrapping
  """
  use GenServer

  require Logger

  # Interval in milliseconds to check again if scrapping is needed
  @interval 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    schedule_scrap()
    {:ok, %{executing: false}}
  end

  def handle_info(:scrap, state) do
    if state.executing do
      Logger.warning("[Scrapper] Already executing")
      # Already executing, just reschedule
      schedule_scrap()
      {:noreply, state}
    else
      Logger.warning("[Scrapper] Scrapping next page")
      # Mark as executing and start scrapping
      new_state = %{state | executing: true}
      Task.start(fn -> perform_scrap() end)
      {:noreply, new_state}
    end
  end

  defp perform_scrap do
    case Xcrapper.Scrapper.scrap_next_page() do
      nil ->
        Logger.warning("[Scrapper] Finished scraping")
        # Scrap finished, reschedule
        GenServer.cast(__MODULE__, :finished)

      _result ->
        Logger.warning("[Scrapper] Continue scraping")
        # Scrap still has more pages, reschedule immediately
        schedule_scrap_now()
    end
  end

  def handle_cast(:finished, state) do
    new_state = %{state | executing: false}
    schedule_scrap()
    {:noreply, new_state}
  end

  defp schedule_scrap do
    Process.send_after(self(), :scrap, @interval)
  end

  defp schedule_scrap_now do
    Process.send(self(), :scrap, [])
  end
end
