require_relative "../config/environment.rb"

class Student
attr_accessor :name, :id , :grade
def initialize(name,grade, id= nil)
  @name = name 
  @grade  = grade 
  @id  = id

end



end
