module Animal 
  class Base
    def speak 
      "I like to "
    end
  end
  
  class Bird < Base
    def speak
      super + "chirp"
    end
  end

  class Dog < Base
    def speak
      super + "whoof"
    end
  end
end