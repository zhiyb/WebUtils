#ifndef MAINW_H
#define MAINW_H

#include <QWidget>
#include <QImage>

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
