require_relative( '../db/sql_runner' )

class Hiker

  attr_accessor :first_name, :last_name, :date_of_birth, :munro_goal
  attr_reader :id

  def initialize(options)
      @id = options['id'].to_i if options['id']
      @first_name = options['first_name']
      @last_name = options['last_name']
      @date_of_birth = options['date_of_birth'] if (options['date_of_birth'] && options['date_of_birth'] != "")
      @munro_goal = options['munro_goal'].to_i if options['munro_goal']
  end

  def save()
    sql = "INSERT INTO hikers
    (
      first_name,
      last_name,
      date_of_birth,
      munro_goal
    )
    VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING id"
    values = [@first_name, @last_name, @date_of_birth, @munro_goal]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM hikers"
    results = SqlRunner.run( sql )
    return results.map { |hiker| Hiker.new(hiker) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM hikers
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Hiker.new(results.first)
  end

  def self.delete_all
    sql = "DELETE FROM hikers"
    SqlRunner.run( sql )
  end

  def update()
     sql = "UPDATE hikers
            SET (first_name, last_name, date_of_birth, munro_goal) = ($1, $2, $3, $4)
            WHERE id = $5"
     values = [@first_name, @last_name, @date_of_birth, @munro_goal, @id]
     SqlRunner.run(sql, values)
   end

   def delete()
     sql = "DELETE FROM hikers
            WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
   end

   def unique_hikes
     sql = "SELECT DISTINCT ON (munros.name)
            munros.id AS munro_id, munros.name, hikes.date FROM munros, hikes
            WHERE hikes.munro_id = munros.id
            AND hikes.hiker_id = $1
            ORDER BY munros.name, hikes.date DESC"
    values = [@id]
    return SqlRunner.run(sql, values)
   end

   def unique_hikes_no
     return unique_hikes.ntuples()
   end

   def all_hikes()
    sql = "SELECT hikes.* FROM hikes
           WHERE hikes.hiker_id = $1
           ORDER BY hikes.date DESC"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map {|munro| Hike.new(munro)}
   end

   def latest_hike
     sql = "SELECT munros.name, TO_CHAR(hikes.date, 'dd/mm/yyyy') AS date FROM munros, hikes
            WHERE hikes.munro_id = munros.id
            AND hikes.hiker_id = $1
            ORDER BY date DESC
            LIMIT 1"
      values = [@id]
     return SqlRunner.run(sql, values)
   end

   def highest_munro
     sql = "SELECT munros.*
            FROM munros INNER JOIN hikes
            ON munros.id = hikes.munro_id
            WHERE hikes.hiker_id = $1
            ORDER BY munros.altitude DESC
            LIMIT 1"
     values = [@id]
     result = SqlRunner.run(sql, values)
     return Munro.new(result[0])
   end

   def full_name()
     return "#{@first_name} #{@last_name}"
   end

   def age
      b_date = @date_of_birth

      b_year = b_date[0..3].to_i
      b_month = b_date[5..6].to_i
      b_day = b_date[8..9].to_i

      time_now = Time.new

      time_now_year = time_now.year
      time_now_month = time_now.month
      time_now_day = time_now.day

      age = time_now_year - b_year

      if time_now_month < b_month || (time_now_month == b_month && time_now_day < b_day)
        age -= 1
      end

      return age

   end

   def self.all_sorted
     all_hikers = Hiker.all()
     hikers_sorted = all_hikers.sort {|hiker1, hiker2| hiker2.unique_hikes_no <=> hiker1.unique_hikes_no}
     return hikers_sorted
   end

   def self.most_active
     return Hiker.all_sorted.first
   end

   def self.most_indiv_hikes
     all_hikers = Hiker.all()
     hikers_sorted = all_hikers.sort {|hiker1, hiker2| hiker2.all_hikes.length <=> hiker1.all_hikes.length}
     return hikers_sorted.first
   end

end
