require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord
  #table name method
  def self.table_name
    "#{self.to_s.downcase.pluralize}"
  end

  #column names method
  def self.column_names

    sql = "pragma table_info('#{table_name}')" #pragma queries info about table

    table_info = DB[:conn].execute(sql)#connects to database
    column_names = [] #creates empty array to store column names
    table_info.each do |row| #runs info through loop
      column_names << row["name"] #shovels column names into array
    end
    column_names.compact #removes all the nil values from hash
  end

  #initialize method
  def initialize(options={})#creates hash for parameters
    options.each do |key, value| #runs through hash
      self.send("#{key}=", value) #takes hash values and creates an equal statement, ex: name = tom
    end
  end

  #table name for insert data
  def table_name_for_insert
    self.class.table_name
  end

  #column name for insert data
  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ") #extracts column names (except for id) and separates them by comas
  end

  #formats column names to be used for sql statement
  def values_for_insert
    values = [] #creates empty array
    self.class.column_names.each do |col_name| #grabs column names and iterates through them
      values << "'#{send(col_name)}'" unless send(col_name).nil?
      #shovels column names into values unless they are nil
    end
  end

  #save method
  def save
    sql = "INSERT INTO #{self.class.table_name}(#{col_names_for_insert}) VALUES(#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  #find by name method


  #find by attribute

end