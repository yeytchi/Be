class SeasonsController < ApplicationController
  before_action :set_season, only: [:show]
  before_action :set_status, only: [:show]

  def index
    if current_user.admin?
      @seasons = Season.all
    else
      @seasons = Season.where(user_id: current_user)
    end
  end

  def new
    @season = Season.new
  end

  def create
    @season = current_user.seasons.new(season_params)

    if @season.save
      redirect_to new_season_team_path(@season.id)
    else
      render :new
    end
  end

  def show
    @my_team = Team.where(user: current_user, season: @season).first
    @teams = Team.where(season_id: @season.id)
    @days = Day.where(season_id: @season.id)

    if @season.status == "complete" && @season.days.empty?
      case @season.number_of_teams
      when 2
        set_two_teams_calendar
      when 4
        set_four_teams_calendar
      when 6
        set_six_teams_calendar
      end
    end

  end

  def destroy

  end

  private

  def season_params
    params.require(:season).permit(:name, :number_of_teams)
  end

  def set_season
    @season = Season.find(params[:id])
  end

  def set_status
    if @season.teams.count == @season.number_of_teams
      @season.status = :complete
      @season.save
    else
      @season.status = :joining
      @season.save
    end
  end

  def set_two_teams_calendar
    teams = Team.where(season_id: @season.id)
    order = (1..@season.number_of_teams).to_a.shuffle
    day_one = Day.create(season: @season)
    day_one_game_one = Game.create(day: day_one, home_team: teams.find(order[0]), away_team: teams.find(order[1]))
  end

  def set_four_teams_calendar
    teams = Team.where(season_id: @season.id)
    order = (1..@season.number_of_teams).to_a.shuffle
    day_one = Day.create(season: @season)
    day_one_game_one = Game.create(day: day_one, home_team: teams.find(order[0]), away_team: teams.find(order[1]))
    day_one_game_two = Game.create(day: day_one, home_team: teams.find(order[2]), away_team: teams.find(order[3]))

    day_two = Day.create(season: @season)
    day_two_game_one = Game.create(day: day_two, home_team: teams.find(order[2]), away_team: teams.find(order[0]))
    day_two_game_two = Game.create(day: day_two, home_team: teams.find(order[3]), away_team: teams.find(order[1]))

    day_three = Day.create(season: @season)
    day_three_game_one = Game.create(home_team: teams.find(order[0]), away_team: teams.find(order[3]))
    day_three_game_two = Game.create(home_team: teams.find(order[2]), away_team: teams.find(order[1]))
  end

  def set_six_teams_calendar
    teams = Team.where(season_id: @season.id)
    order = (1..@season.number_of_teams).to_a.shuffle

    day_one = Day.create(season: @season)
    day_one_game_one = Game.create(day: day_one, home_team: teams.find(order[0]), away_team: teams.find(order[1]))
    day_one_game_two = Game.create(day: day_one, home_team: teams.find(order[2]), away_team: teams.find(order[3]))
    day_one_game_three = Game.create(day: day_one, home_team: teams.find(order[4]), away_team: teams.find(order[5]))

    day_two = Day.create(season: @season)
    day_two_game_one = Game.create(day: day_two, home_team: teams.find(order[2]), away_team: teams.find(order[0]))
    day_two_game_two = Game.create(day: day_two, home_team: teams.find(order[3]), away_team: teams.find(order[4]))
    day_two_game_three = Game.create(day: day_two, home_team: teams.find(order[5]), away_team: teams.find(order[1]))

    day_three = Day.create(season: @season)
    day_three_game_one = Game.create(day: day_three, home_team: teams.find(order[0]), away_team: teams.find(order[3]))
    day_three_game_two = Game.create(day: day_three, home_team: teams.find(order[4]), away_team: teams.find(order[1]))
    day_three_game_three = Game.create(day: day_three, home_team: teams.find(order[5]), away_team: teams.find(order[2]))

    day_four = Day.create(season: @season)
    day_four_game_one = Game.create(day: day_four, home_team: teams.find(order[0]), away_team: teams.find(order[4]))
    day_four_game_two = Game.create(day: day_four, home_team: teams.find(order[1]), away_team: teams.find(order[2]))
    day_four_game_three = Game.create(day: day_four, home_team: teams.find(order[3]), away_team: teams.find(order[5]))

    day_five = Day.create(season: @season)
    day_five_game_one = Game.create(day: day_five, home_team: teams.find(order[5]), away_team: teams.find(order[0]))
    day_five_game_two = Game.create(day: day_five, home_team: teams.find(order[1]), away_team: teams.find(order[3]))
    day_five_game_three = Game.create(day: day_five, home_team: teams.find(order[2]), away_team: teams.find(order[4]))
  end
end
