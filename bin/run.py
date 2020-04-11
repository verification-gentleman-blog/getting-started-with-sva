#!/usr/bin/env python3

import click

@click.group()
@click.argument('task')
@click.pass_context
def cli(ctx, task):
    ctx.ensure_object(dict)
    ctx.obj['task'] = task

@cli.command()
@click.pass_context
def sby(ctx):
    click.echo('Running sby with task {}'.format(ctx.obj['task']))

@cli.command()
@click.pass_context
def gtkwave(ctx):
    click.echo('Running gtkwave with task {}'.format(ctx.obj['task']))

if __name__ == '__main__':
    cli()
