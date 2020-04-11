#!/usr/bin/env python3

import click

@click.group()
def cli():
    pass

@cli.command()
def sby():
    click.echo('Running sby')

@cli.command()
def gtkwave():
    click.echo('Running gtkwave')

if __name__ == '__main__':
    cli()
