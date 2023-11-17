cmake_minimum_required(VERSION 3.16)

project(meeting_room_rsv VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(FLUENTUI_BUILD_EXAMPLES OFF)
set(FLUENTUI_BUILD_FRAMELESSHELPER OFF)
find_package(Qt6 REQUIRED Sql COMPONENTS Quick)

set(source_files
    src/main.cpp
    src/SettingsHelper.cpp
    src/SettingsHelper.h
    src/singleton.h
    src/AppInfo.cpp
    src/AppInfo.h
    src/stdafx.h
    src/Version.h
    src/CircularReveal.cpp
    src/CircularReveal.h
    src/DatabaseManager.cpp
    src/DatabaseManager.h
)
qt_standard_project_setup()

qt_add_executable(meeting_room_rsv
    ${source_files}
)


# 遍历QML文件
file(GLOB_RECURSE qml_paths "qml/*.qml")
foreach(qml_path ${qml_paths})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" rel_qml_path ${qml_path})
#    get_filename_component(file_name ${qml_path} NAME)
    set_source_files_properties(${qml_path} PROPERTIES QT_RESOURCE_ALIAS ${rel_qml_path})
endforeach(qml_path)

file(GLOB_RECURSE res_paths "res/*.png" "res/*.jpg" "res/*.svg" "res/*.ico" "res/*.ttf" "res/*.webp" "res/*.obj")
foreach(res_path ${res_paths})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" rel_res_path ${res_path})
    set_source_files_properties(${res_path} PROPERTIES QT_RESOURCE_ALIAS ${rel_res_path})
endforeach(res_path)



qt_add_qml_module(meeting_room_rsv
    URI meeting_room_rsv
    VERSION 1.0
    RESOURCE_PREFIX "/"
    SOURCES ${source_files}
    QML_FILES ${qml_paths}
    RESOURCES ${res_paths}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(meeting_room_rsv PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.meeting_room_rsv.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(meeting_room_rsv
    PRIVATE Qt6::Quick
    fluentuiplugin
    Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS meeting_room_rsv
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

add_subdirectory(FluentUI)
