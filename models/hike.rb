require_relative( '../db/sql_runner' )

class Hike

  attr_reader :id, :hiker_id, :munro_id
  attr_accessor :date

  def initialize(options)
      @id = options['id'].to_i if options['id']
      @hiker_id = options['hiker_id']
      @munro_id = options['munro_id']
      @date = options['date']
  end

  def save()
    sql = "INSERT INTO hikes
    (
      hiker_id,
      munro_id,
      date
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@hiker_id, @munro_id, @date]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM hikes
           ORDER BY hikes.date DESC"
    results = SqlRunner.run( sql )
    return results.map { |hike| Hike.new(hike) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM hikes
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Hike.new(results.first)
  end

  def self.delete_all
    sql = "DELETE FROM hikes"
    SqlRunner.run( sql )
  end

  def update()
     sql = "UPDATE hikes
            SET (hiker_id, munro_id, date) = ($1, $2, $3)
            WHERE id = $4"
     values = [@hiker_id, @munro_id, @date, @id]
     SqlRunner.run(sql, values)
   end

   def delete()
     sql = "DELETE FROM hikes
            WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
   end

   def hiker()
     sql = "SELECT * FROM hikers
    WHERE id = $1"
     values = [@hiker_id]
     result = SqlRunner.run(sql, values)
     return Hiker.new(result[0])
     # return hiker = result.map{|hiker| Hiker.new(hiker)}
   end

   def munro()
     sql = "SELECT * FROM munros
    WHERE id = $1"
     values = [@munro_id]
     result = SqlRunner.run(sql, values)
     return Munro.new(result[0])
     # return hiker = result.map{|hiker| Hiker.new(hiker)}
   end



end
