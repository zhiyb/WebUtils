#include <QApplication>
#include "mainw.h"

int main(int argc, char *argv[])
{
	if (argc != 2)
		return 1;
	QApplication a(argc, argv);
	MainW w(argv[1]);
	w.resize(w.image().size());
	w.show();
	return a.exec();
}
