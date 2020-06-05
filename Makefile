docker:=$(shell which docker)
ifneq (${docker},)
  repo:=jfritzbarnes
  tag:=$(shell date +'%Y%m%d.%H%M')
  prev_image:=$(shell docker images | grep ${repo} | awk '{print $$2}' | head -1)
endif

dbuild:
	docker build . -t ${repo}:${tag}
	docker tag ${repo}:${tag} ${repo}:latest

dpush:
	docker push ${repo}:${prev_image}

gobuild:
	docker build ./golang -t ${repo}/devgo:${tag}
	docker tag ${repo}/devgo:${tag} ${repo}/devgo:latest

clean:
	docker images | grep ${repo}/devgo | awk '{print $2}' | tail -n +3 | \
		xargs -n 1 printf '${repo}/devgo:%s\n' | xargs -n 1 docker rmi

.PHONY: dbuild dpush clean
