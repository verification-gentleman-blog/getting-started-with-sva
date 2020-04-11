#!/usr/bin/env python3

import pathlib
import subprocess

import click

sby_files = list(pathlib.Path.cwd().glob('*.sby'))
assert len(sby_files) == 1, 'expected a single sby file in this directory'

SBY_FILE = sby_files[0].name
TASKS = subprocess.check_output(
            ['sby', SBY_FILE, '--dumptasks'],
            universal_newlines=True).split()

@click.group(context_settings=dict(help_option_names=['-h', '--help']))
@click.option('--task', '-t', required=True, type=click.Choice(TASKS))
@click.pass_context
def cli(ctx, task):
    ctx.ensure_object(dict)
    ctx.obj['task'] = task

@cli.command()
@click.pass_context
def sby(ctx):
    click.echo('Running sby with task {}'.format(ctx.obj['task']))
    subprocess.call(['sby', '-f', SBY_FILE, ctx.obj['task']])

@cli.command()
@click.pass_context
def gtkwave(ctx):
    click.echo('Running gtkwave with task {}'.format(ctx.obj['task']))

if __name__ == '__main__':
    cli()
