import logging


def get_logger(logger_name: str = None, level: str = "INFO") -> logging.Logger:
    name = logger_name if logger_name else __name__
    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.handlers = []
    sh = logging.StreamHandler()
    log_format = logging.Formatter("%(asctime)s - %(name)s - [%(levelname)s] - %(message)s")
    sh.setFormatter(log_format)
    logger.addHandler(sh)
    return logger
