from conans import ConanFile, CMake

class RistrettoConan(ConanFile):
    author = "Mike Kaliman"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake", "gcc", "txt"
    options = {"build_server" : [True, False],
               "build_client" : [True, False]}
    default_options = {"build_server" : False,
                       "build_client" : True}

    def requirements(self):
        self.requires("gtest/1.10.0")
        self.requires("docopt.cpp/0.6.2")
        self.requires("fmt/6.2.0")
        self.requires("spdlog/1.5.0")
        # I was trying to use conan for this instead of the ysstem package manager
        # However, i couldn't get the recipe to generate the protoc binaries
        # Seems like stable doesnt add the .cmake to the cmake modules path
        self.requires("protobuf/3.9.1")
        # Not using these anymore
        #self.requires("boost/1.71.0")
        #self.requires(""abseil/20200205")


    def build(self):
        # Run "conan install . --build missing" to build all missing dependencies
        cmake = CMake(self)
        if self.options["build_server"]:
            cmake.definitions["BUILD_SERVER"] = "ON"
        else:
            cmake.definitions["BUILD_SERVER"] = "OFF"

        if self.options["build_client"]:
            cmake.definitions["BUILD_CLIENT"] = "ON"
        else:
            cmake.definitions["BUILD_CLIENT"] = "OFF"
        cmake.generator = "Ninja"
        cmake.configure()
        cmake.build()
