QT	+= core gui

greaterThan(QT_MAJOR_VERSION, 4): QT	+= widgets

TARGET	= ImageViewer
TEMPLATE	= app

SOURCES	+= main.cpp mainw.cpp
HEADERS += mainw.h
