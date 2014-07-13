#ifndef MAINW_H
#define MAINW_H

#include <qwidget.h>
#include <qimage.h>

class MainW : public QWidget
{
	Q_OBJECT
public:
	MainW(char *path, QWidget *parent = 0);
	QImage image(void) const {return img;}

protected:
	void paintEvent(QPaintEvent *);

private:
	QImage img;
};

#endif
