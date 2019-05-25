#include <qpainter.h>
#include <iostream>
#include "mainw.h"

MainW::MainW(char *path, QWidget *parent) : QWidget(parent)
{
	img = QImage(path);
	setMinimumSize(img.size());
	setCaption(tr("Image viewer"));
}

void MainW::paintEvent(QPaintEvent *)
{
	float factor = std::min((float)width() / img.width(), \
				(float)height() / img.height());
	QImage i = img.smoothScale((int)(img.width() * factor), \
			(int)(img.height() * factor));
	QPainter painter(this);
	painter.drawImage(QPoint((int)((width() - i.width()) / 2), \
			(int)((height() - i.height()) / 2)), \
			i, i.rect());
}
