#include <QPainter>
#include "mainw.h"

MainW::MainW(char *path, QWidget *parent) : QWidget(parent)
{
	img.load(path);
	setMinimumSize(img.size());
	setWindowTitle(tr("Image viewer"));
}

void MainW::paintEvent(QPaintEvent *)
{
	qreal factor = std::min((qreal)width() / img.width(), \
				(qreal)height() / img.height());
	QRectF rect((width() - img.width() * factor) / 2, \
		    (height() - img.height() * factor) / 2, \
		    img.width() * factor, \
		    img.height() * factor);
	QPainter painter(this);
	painter.drawImage(rect, img, img.rect());
}
