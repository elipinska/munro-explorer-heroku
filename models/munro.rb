require_relative( '../db/sql_runner' )

class Munro

  attr_accessor :name, :region, :altitude
  attr_reader :id

  def initialize(options)
      @id = options['id'].to_i if options['id']
      @name = options['name']
      @region = options['region']
      @altitude = options['altitude'].to_i
  end

  def save()
    sql = "INSERT INTO munros
    (
      name,
      region,
      altitude
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@name, @region, @altitude]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM munros ORDER BY name"
    results = SqlRunner.run( sql )
    return results.map { |munro| Munro.new(munro) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM munros
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Munro.new(results.first)
  end

  def self.delete_all
    sql = "DELETE FROM munros"
    SqlRunner.run(sql)
  end

  def update()
     sql = "UPDATE munros
            SET (name, region, altitude) = ($1, $2, $3)
            WHERE id = $4"
     values = [@name, @region, @altitude, @id]
     SqlRunner.run(sql, values)
   end

   def delete()
     sql = "DELETE FROM munros
            WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
   end

   def all_hikers()
     sql = "SELECT DISTINCT hikers.* FROM hikers
            INNER JOIN hikes
            ON hikers.id = hikes.hiker_id
            WHERE hikes.munro_id = $1"
     values = [@id]
     results = SqlRunner.run(sql, values)
     return results.map {|hiker| Hiker.new(hiker)}
   end

   def all_hikes()
     sql = "SELECT DISTINCT hikes.* FROM hikes
            WHERE hikes.munro_id = $1"
     values = [@id]
     results = SqlRunner.run(sql, values)
     return results.map {|hike| Hike.new(hike)}
   end

   def self.most_popular
     all_munros = Munro.all()
     munros_sorted = all_munros.sort {|munro1, munro2| munro1.all_hikers.length <=> munro2.all_hikers.length}
     return munros_sorted.last
   end

   def self.most_indiv_visits
     all_munros = Munro.all()
     munros_sorted = all_munros.sort {|munro1, munro2| munro1.all_hikes.length <=> munro2.all_hikes.length}
     return munros_sorted.last
   end



end
