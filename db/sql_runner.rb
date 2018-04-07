require( 'pg' )

class SqlRunner

  def self.run( sql, values = [] )
    begin
      db_info = ENV['DATABASE_URL'].nil? ? {dbname: 'munro_bagger', host: 'localhost'} : ENV['DATABASE_URL']
      db = PG.connect(db_info)
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close() if db != nil
    end
    return result
  end

end
