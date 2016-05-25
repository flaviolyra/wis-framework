# -*- coding: utf-8 -*-
"""
/***************************************************************************
 MontanteJusanteTabela
                                 A QGIS plugin
 cria e exibe tabelas area montante e curso jusante
                             -------------------
        begin                : 2015-12-22
        copyright            : (C) 2015 by Flavio Lyra
        email                : flavio.jose.lyra@gmail.com
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load MontanteJusanteTabela class from file MontanteJusanteTabela.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .montante_jusante_tabela import MontanteJusanteTabela
    return MontanteJusanteTabela(iface)
