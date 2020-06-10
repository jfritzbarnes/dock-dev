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

nodebuild:
	docker build ./node -t ${repo}/devnode:${tag}
	docker tag ${repo}/devnode:${tag} ${repo}/devnode:latest

scalabuild:
	docker build ./scala -t ${repo}/devscala:${tag}
	docker tag ${repo}/devscala:${tag} ${repo}/devscala:latest

clean:
	docker images | grep ${repo}/devgo | awk '{print $2}' | tail -n +3 | \
		xargs -n 1 printf '${repo}/devgo:%s\n' | xargs -n 1 docker rmi
	docker images | grep ${repo}/devnode | awk '{print $2}' | tail -n +3 | \
		xargs -n 1 printf '${repo}/devnode:%s\n' | xargs -n 1 docker rmi
	docker images | grep ${repo}/devnscala | awk '{print $2}' | tail -n +3 | \
		xargs -n 1 printf '${repo}/devscala:%s\n' | xargs -n 1 docker rmi

.PHONY: dbuild dpush clean gobuild nodebuild
