#include <qpe/qpeapplication.h>
#include "mainw.h"

int main(int argc, char *argv[])
{
	if (argc != 2)
		return 1;
	QPEApplication a(argc, argv);
	MainW w(argv[1]);
	a.setMainWidget(&w);
	w.resize(w.image().size());
	w.showMaximized();
	return a.exec();
}
