require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

   def initialize(id=nil, name, grade)
     @id = id
     @name = name
     @grade = grade
   end

   def self.create_table
     sql = <<-SQL
       CREATE TABLE IF NOT EXISTS students (
       id INTEGER PRIMARY KEY,
       name TEXT,
       grade TEXT
                 )
     SQL

     DB[:conn].execute(sql)
   end

   def self.drop_table
     sql ="DROP TABLE IF EXISTS students"
     DB[:conn].execute(sql)
   end

   def save
     if self.id
         self.update
     else
       sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
       DB[:conn].execute(sql, self.name, self.grade)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten.first
     end
   end

   def update
     sql = "UPDATE students SET name =?,grade=? WHERE id=?"
     DB[:conn].execute(sql, self.name, self.grade, self.id)
   end

   def self.create(name, grade)
     student = self.new(name, grade)
     student.save
     student
   end

   def self.new_from_db(row)
     new_student = self.new(row[0], row[1], row[2])
     new_student
   end

   def self.find_by_name(name)
     sql = "SELECT * FROM students WHERE name = ?"
     DB[:conn].execute(sql, name).map {|student| self.new_from_db(student)}.first
   end
end
